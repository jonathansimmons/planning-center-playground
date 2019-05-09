# frozen_string_literal: true

module PlanningCenter
  extend ActiveSupport::Concern

  included do
    def create_family
      @members = []
      person = create_person(params[:primary])
      if person.present?
        if params[:guardians].present?
          guardians = params[:guardians].first
          guardians.keys.count.times do |index|
            guardian = index + 1
            create_person(guardians[guardian.to_s])
          end
        end

        if params[:children].present?
          children = params[:children].first
          children.keys.count.times do |index|
            child = index + 1
            create_person(children[child.to_s], true)
          end
        end

        create_household(person, @members)
      end
      true
    end
  end

  private

  def create_person(data, child = false)
    person = PCI.people.v2.people.post(
      data: {
        type: "Person",
        attributes: {
          first_name: data[:attributes][:first_name],
          last_name: data[:attributes][:last_name],
          gender: data[:attributes][:gender],
          grade: data[:attributes][:grade],
          birthdate: data[:attributes][:birthday],
          child: child,
        },
      },
    )
    create_address(params, person["data"]["id"])
    unless child
      create_email(data[:attributes][:email], person["data"]["id"])
      create_phone(data[:attributes][:phone], person["data"]["id"])
    end
    @members << person
    person
  end

  def create_address(data, person_id)
    PCI.people.v2.people[person_id].addresses.post(
      data: {
        type: "Address",
        attributes: {
          street: data[:primary][:attributes][:street],
          city: data[:primary][:attributes][:city],
          state: data[:primary][:attributes][:state],
          zip: data[:primary][:attributes][:zip],
          location: "Home",
          primary: true,
        },
      },
    )
  end

  def create_email(email, person_id)
    PCI.people.v2.people[person_id].emails.post(
      data: {
        type: "Email",
        attributes: {
          address: email,
          location: "Home",
          primary: true,
        },
      },
    )
  end

  def create_phone(phone, person_id)
    PCI.people.v2.people[person_id].phone_numbers.post(
      data: {
        type: "PhoneNumber",
        attributes: {
          number: phone,
          location: "Home",
          primary: true,
        },
      },
    )
  end

  def create_household(primary_contact, members)
    PCI.people.v2.households.post(
      "data": {
        type: "Household",
        attributes: {
          name: "#{primary_contact['data']['attributes']['last_name']} " \
                "Household",
        },
        relationships: {
          people: {
            "data": members.map do |member|
                      { type: "Person",
                        id: member["data"]["id"] }
                    end,
          },
          primary_contact: {
            data: { type: "Person", id: primary_contact["data"]["id"] },
          },
        },
      },
    )
  end
end
