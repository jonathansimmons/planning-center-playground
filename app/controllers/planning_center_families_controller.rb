# frozen_string_literal: true

class PlanningCenterFamiliesController < ApplicationController
  skip_before_action :verify_authenticity_token
  helper_method :first_time_workflow_id
  rescue_from PCO::API::Errors::BaseError, with: :redirect_to_error_page

  def index; end

  def new; end

  def create
    create_family
    redirect_to thank_you_url(campus: params[:campus])
  end

  def thank_you; end

  def error; end

  private

  def create_family
    @members = []
    person = create_person(params[:primary])
    if person.present?
      if params[:guardians].present?
        guardians = params[:guardians].first
        guardian_count = guardians.keys.count
        guardian_count.times do |index|
          guardian = index + 1
          create_person(guardians[guardian.to_s])
        end
      end

      if params[:children].present?
        children = params[:children].first
        children_count = children.keys.count

        children_count.times do |index|
          child = index + 1
          create_person(children[child.to_s], true)
        end
      end

      household = create_household(person, @members)

      # add_to_first_time_workflow(person["data"]["id"])
    end
  end

  def add_to_first_time_workflow(person_id)
    PCI.people.v2.workflows[first_time_workflow_id].cards.post(
      data: {
        type: 'Workflow Card',
        attributes: {
          person_id: person_id,
          sticky_assignment: false
        }
      }
    )
  end

  def create_person(data, child = false)
    logger.debug("creating person: #{data.inspect}")
    person = PCI.people.v2.people.post(
      data: {
        type: 'Person',
        attributes: {
          first_name: data[:attributes][:first_name],
          last_name: data[:attributes][:last_name],
          gender: data[:attributes][:gender],
          grade: data[:attributes][:grade],
          birthdate: data[:attributes][:birthday],
          child: child
        }
      }
    )
    create_address(params, person['data']['id'])
    unless child
      create_email(data[:attributes][:email], person['data']['id'])
      create_phone(data[:attributes][:phone], person['data']['id'])
    end
    logger.debug person.inspect
    @members << person
    person
  end

  def create_address(data, person_id)
    PCI.people.v2.people[person_id].addresses.post(
      data: {
        type: 'Address',
        attributes: {
          street: data[:primary][:attributes][:street],
          city: data[:primary][:attributes][:city],
          state: data[:primary][:attributes][:state],
          zip: data[:primary][:attributes][:zip],
          location: 'Home',
          primary: true
        }
      }
    )
  end

  def create_email(email, person_id)
    PCI.people.v2.people[person_id].emails.post(
      data: {
        type: 'Email',
        attributes: {
          address: email,
          location: 'Home',
          primary: true
        }
      }
    )
  end

  def create_phone(phone, person_id)
    PCI.people.v2.people[person_id].phone_numbers.post(
      data: {
        type: 'PhoneNumber',
        attributes: {
          number: phone,
          location: 'Home',
          primary: true
        }
      }
    )
  end

  def create_household(primary_contact, members)
    PCI.people.v2.households.post(
      "data": {
        type: 'Household',
        attributes: {
          name: "#{primary_contact['data']['attributes']['last_name']} Household"
        },
        relationships: {
          people: {
            "data": members.map { |member| { type: 'Person', id: member['data']['id'] } }
          },
          primary_contact: {
            data: { type: 'Person', id: primary_contact['data']['id'] }
          }
        }
      }
    )
  end

  def first_time_workflow_id
    @first_time_workflow_id ||= case params[:campus]
                                when 'dallas'
                                  67_385
                                when 'frisco'
                                  68_457
                                when 'grand-prairie'
                                  68_458
                                when 'north-fort-worth'
                                  68_459
                                when 'nrh'
                                  68_460
                                when 'southlake'
                                  68_461
                                end
  end

  def redirect_to_error_page(error)
    Rails.logger.debug "error: \n #{error.inspect}"
    redirect_to error_url
    nil
  end
end
