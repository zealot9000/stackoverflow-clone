ThinkingSphinx::Index.define :question, with: :active_record do
  #fields
  indexes title, sortable: true
  indexes body
  indexes user.email, as: :author, sortable: true
end