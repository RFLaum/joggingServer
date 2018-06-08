class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end


class ActiveRecord::Relation
  def paginate(page_num, per_page)
    unscope(:limit, :offset).limit(per_page).offset((page_num - 1) * per_page)
  end
end
