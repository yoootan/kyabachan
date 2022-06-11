class StatusesController < ApplicationController
  # skip_before_action :basic_auth

  def healthcheck
    render plain: 'ok'
  end

  def version
    @git_branch = `git status | sed -n 1p`.split(" ").last
    @git_commit_long = `git rev-parse HEAD`.split(" ").last
    @git_commit_short = `git rev-parse --short HEAD`.split(" ").last
    render plain: "branch: #{@git_branch} | commit: #{@git_commit_short} (#{@git_commit_long})"
  end
end
