# frozen_string_literal: true

PCI = PCO::API.new(
  basic_auth_token: Rails.application.credentials[:planning_center][:basic_auth_token],
  basic_auth_secret: Rails.application.credentials[:planning_center][:basic_auth_secret]
)
