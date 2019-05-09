# frozen_string_literal: true

class PlanningCenterFamiliesController < ApplicationController
  include PlanningCenter
  skip_before_action :verify_authenticity_token
  rescue_from PCO::API::Errors::BaseError, with: :redirect_to_error_page

  def index; end

  def new; end

  def create
    if create_family
      redirect_to thank_you_url
    else
      redirect_to error_url
    end
  end

  def thank_you; end

  def error; end

  private

  def redirect_to_error_page(error)
    Rails.logger.debug "error: \n #{error.inspect}"
    redirect_to error_url
    nil
  end
end
