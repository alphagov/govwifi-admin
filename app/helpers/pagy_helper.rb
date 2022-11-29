module PagyHelper
  include Pagy::Frontend

  def pagy_nav_govuk(pagy)
    return "" if pagy.pages == 1

    link   = pagy_link_proc(pagy, link_extra: "class='govuk-link'")
    p_prev = pagy.prev
    p_next = pagy.next

    html = +%(<nav class="pager__govwifi govuk-body" role="navigation" aria-label="Pagination">)
    html << %(<div class="pager__summary">Showing #{pagy.from}-#{pagy.to} of #{pagy.count} items</div>)
    html << %(<div class="pager__controls">)
    if p_prev
      html << (link_to "Prev", pagy_url_for(pagy, p_prev), class: "pager__prev govuk-link", rel: "prev")
    end
    html << %(<ul class="pager__items">)
    pagy.series.each do |item|  # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
      html << case item
              when Integer then %(<li>#{link.call item}</li>) # page link
              when String  then %(<li>#{item}</li>) # current page
              when :gap    then %(<li">#{pagy_t('pagy.nav.gap')}</li>)   # page gap
              end
    end
    html << %(</ul>)
    if p_next
      html << (link_to "Next", pagy_url_for(pagy, p_next), class: "pager__next govuk-link", rel: "next")
    end
    html << %(</div>)
    html << %(</nav>)
  end
end
