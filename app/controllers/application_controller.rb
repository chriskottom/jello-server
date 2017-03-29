class ApplicationController < ActionController::API
  include RespondsWithError

  rescue_from ActiveRecord::RecordNotFound, with: :respond_with_not_found

  private

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
