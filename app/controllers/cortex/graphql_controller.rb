require_dependency 'cortex/application_controller'

module Cortex
  class GraphqlController < ApplicationController
    def execute
      variables = ensure_hash(params[:variables])
      query = params[:query]
      operation_name = params[:operationName]
      context = {
        current_user: current_user
      }
      result = Cortex::CortexSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
      render json: result
    end

    def ide
      add_breadcrumb 'GraphQL IDE', :graphql_ide_path
    end

    private

    # Handle form data, JSON body, or a blank value
    def ensure_hash(ambiguous_param)
      case ambiguous_param
        when String
          if ambiguous_param.present?
            ensure_hash(JSON.parse(ambiguous_param))
          else
            {}
          end
        when Hash, ActionController::Parameters
          ambiguous_param
        when nil
          {}
        else
          raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
      end
    end
  end
end
