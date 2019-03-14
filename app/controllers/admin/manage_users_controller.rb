class Admin::ManageUsersController < AdminController
  helper_method :sort_column, :sort_direction

  def index
    unconfirmed_user = User.where(confirmed_at: nil)
    @all_unconfirmed_users = unconfirmed_user.order("#{sort_column} #{sort_direction}")
  end

  private

  def sortable_columns
    %w[email created_at]
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
