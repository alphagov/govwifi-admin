module UseCases
  module Administrator
    class CreateOrganisationWhitelist
      def execute(organisation_names)
        return "empty" if organisation_names.empty?

        organisation_names_list(organisation_names)
      end

    private

      def organisation_names_list(organisation_names)
        "- #{organisation_names.join(' ')}"
      end
    end
  end
end
