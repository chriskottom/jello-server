class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :respond_with_not_found

  private

  def render_error(status, resource = nil)
    render status: status,
           json: (resource ? { error: resource } : nil)
  end

  def respond_with_not_found(exception)
    render_error :not_found,
                 {
                   status: 404,
                   name: "Not found",
                   message: exception.message
                 }
  end

  def respond_with_validation_error(model, errors = nil)
    render_error :unprocessable_entity,
                 {
                   status: 422,
                   name: "Validation failed",
                   errors: (errors || model.errors)
                 }
  end

  def pagination_meta(collection)
    return nil unless collection.respond_to?(:current_page)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end
end
