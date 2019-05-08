module UseCases
  module Administrator
    class FormatOrganisationNames
      def execute(organisation_names)
        return "" if organisation_names.empty?

        organisation_names_list(organisation_names)
      end

    private

      def organisation_names_list(organisation_names)
        "- #{organisation_names.join('\n- ')}"
      end
    end
  end
end
