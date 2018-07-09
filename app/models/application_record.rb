class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class ActiveRecord::Relation
  def paginate(page_num, per_page)
    page_num ||= 1
    per_page ||= 20
    page_num = page_num.to_i
    per_page = per_page.to_i
    return self if per_page <= 0
    unscope(:limit, :offset).limit(per_page).offset((page_num - 1) * per_page)
  end
end
