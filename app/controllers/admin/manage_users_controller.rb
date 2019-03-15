class Admin::ManageUsersController < AdminController
  helper_method :sort_column, :sort_direction

  def index
    @all_unconfirmed_users = User.where(confirmed_at: nil).order("#{sort_column} #{sort_direction}")
  end

  def destroy
    user = User.find_by(id: params.fetch(:id))
    user.destroy
    redirect_to admin_manage_users_path, notice: "Unconfirmed user has been removed"
  end

private

  def sortable_columns
    %w[email]
  end

  def sortable_directions
    %w[asc]
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : sortable_columns.first
  end

  def sort_direction
    sortable_directions.include?(params[:direction]) ? params[:direction] : sortable_directions.first
  end
end
