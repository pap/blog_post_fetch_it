module V1
  module ApiResources
    class Hello
      include Praxis::ResourceDefinition

      media_type V1::MediaTypes::Hello
      version '1.0'

      prefix '/api/hello'

      # Will apply to all actions of this resource
      trait :authorized

      action_defaults do
        response :ok
      end

      action :index do

        routing do
          get ''
        end
      end

      action :show do

        routing do
          get '/:id'
        end
        params do
          attribute :id, Integer, required: true, min: 0
        end
        response :not_found
      end
    end
  end
end
