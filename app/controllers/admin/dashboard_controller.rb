module Admin
  class DashboardController < ApplicationController
    before_action :authorize_admin!

    def show
      @stats = AdminStatsQuery.new.call
    end
  end
end
