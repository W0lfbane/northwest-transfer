class DocumentsController < Flexible::ApplicationController
  include Concerns::Resource::State::ResourceStateChange

  before_action :authenticate_user!

  private

    def document_params
      params.require(:document).permit(:title,
                                        :signature, 
                                        :resource_state, 
                                        :completion_date, 
                                        :customer_firstname, 
                                        :customer_lastname, 
                                        :ems_order_no, 
                                        :technician, 
                                        :shipper, 
                                        :make, 
                                        :brand, 
                                        :itm_model, 
                                        :age, 
                                        :itm_length, 
                                        :itm_width, 
                                        :itm_height, 
                                        :itm_name, 
                                        :itm_condition)
    end

end