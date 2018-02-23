class YanksController < ApplicationController

  def index
    Member.connection.clear_query_cache
    @m = Member.where(curl: nil)
    #@m = Member.all
  end

end