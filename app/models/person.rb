class Person < ApplicationRecord
    has_paper_trail

    has_many :versions, class_name: 'PaperTrail::Version', as: :item
end
