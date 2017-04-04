module JSONAPI
  module ErrorRendering
    private

    def render_error(status, resource = nil)
            render status: status,
                   json: resource,
                   serializer: ActiveModel::Serializer::ErrorSerializer
    end

    def respond_with_not_found(exception)
      resource_class = controller_name.classify.constantize
      resource = resource_class.new(id: params[:id])
      resource.errors.add(:id, 'not found')
      render_error :not_found, resource
    end

    def respond_with_validation_error(model, errors = nil)
      render :unprocessable_entity, model
    end
  end
end
