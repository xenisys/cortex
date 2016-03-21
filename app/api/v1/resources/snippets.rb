require_relative '../helpers/resource_helper'

module API
  module V1
    module Resources
      class Snippets < Grape::API
        helpers Helpers::ParamsHelper

        resource :snippets do
          include Grape::Kaminari
          helpers Helpers::SnippetsHelper

          paginate per_page: 25

          desc 'Show all snippets', { entity: Entities::Snippet, nickname: 'showAllSnippet' }
          get do
            authorize! :view, ::Snippet
            require_scope! :'view:snippets'

            @snippet = ::Snippet.order(created_at: :desc)
            Entities::Snippet.represent paginate(@snippet)
          end

          desc 'Get snippet', { entity: Entities::Snippet, nickname: 'showSnippet' }
          get ':id' do
            require_scope! :'view:snippets'
            authorize! :view, snippet!

            present snippet, with: Entities::Snippet
          end

          desc 'Create snippet', { entity: Entities::Snippet, params: Entities::Snippet.documentation, nickname: 'createSnippet' }
          post do
            require_scope! :'modify:snippets'
            authorize! :create, ::Snippet

            snippet_params = params[:snippet] || params

            @snippet = ::Snippet.new(declared(snippet_params, { include_missing: false }, Entities::Snippet.documentation.keys))
            snippet.user = current_user!
            snippet.save!

            present snippet, with: Entities::Snippet
          end

          desc 'Update snippet', { entity: Entities::Snippet, params: Entities::Snippet.documentation, nickname: 'updateSnippet' }
          put ':id' do
            require_scope! :'modify:snippets'
            authorize! :update, snippet!

            snippet_params = params[:snippet] || params

            snippet.update!(declared(snippet_params, { include_missing: false }, Entities::Snippet.documentation.keys))

            present snippet, with: Entities::Snippet
          end

          desc 'Delete snippet', { nickname: 'deleteSnippet' }
          delete ':id' do
            require_scope! :'modify:snippets'
            authorize! :delete, snippet!

            begin
              snippet.destroy
            rescue Cortex::Exceptions::ResourceConsumed => e
              error = error!({
                               error:   'Conflict',
                               message: e.message,
                               status:  409
                             }, 409)
              error
            end
          end
        end
      end
    end
  end
end
