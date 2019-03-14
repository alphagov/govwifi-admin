class Admin::ManageUsersController < AdminController
  helper_method :sort_column, :sort_direction

  def index
    @all_unconfirmed_users = User.where(confirmed_at: nil).order("#{sort_column} #{sort_direction}")
  end

  private

  def sortable_columns
    %w[email]
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : "email"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
