class SystemsController < ApplicationController
  # skip_before_action :basic_auth

  def hostname
    render plain: `hostname -f`
  end

  def datetime
    render plain: `date "+%Y/%m/%d %H:%M:%S"`
  end
end
