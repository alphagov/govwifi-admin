module UseCases
  module Administrator
    class CreateOrganisationWhitelist

      def execute(organisation_names)
        return "empty" if organisation_names.empty?

        "Custom Org name"
      end

    private

      def organisation_names_list(organisation_names)
        "- #{organisation_names.join}"
      end

    end
  end
end
