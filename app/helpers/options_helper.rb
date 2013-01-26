module OptionsHelper

  def render_collection_of_options(frm, collection)
    content_tag :table, :class => 'options_table hilite' do
      content = ''
      collection.each do |attrib|
        content << (render :partial => 'option', :locals => {:attrib => attrib, :f => frm})
      end
      content
    end
  end

end

