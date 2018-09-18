FactoryBot.define do
  factory :expenses_data, class: Hash do
    draw { 1 }
    columns do
      {
        "0" => { data: 'category', name: '', searchable: true, orderable: true, search: { value: '', regex: false } },
        "1" => { data: 'total', name: '', searchable: true, orderable: true, search: { value: '', regex: false } },
        "2" => { data: 'paid_at', name: '', searchable: true, orderable: true, search: { value: '', regex: false } },
        "3" => { data: 'tags', name: '', searchable: true, orderable: true, search: { value: '', regex: false } },
        "4" => { data: 'path', name: '', searchable: true, orderable: false, search: { value: '', regex: false } }
      }
    end
    order do
      { 
        "0" => { column: 0, dir: 'asc' } 
      }
    end
    start { 0 }
    length { 10 }
    search do
      { value: '', regex: false }
    end
    
  end
end