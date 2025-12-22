class PagesController < ApplicationController
  def index
  end
  def about
  end
  def contact
    @contact = Contact.new
  end

  def create_contact
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to "/contact", notice: "Thank you! Your message was sent and we´ll reply as soon as possible."
    else
      render :contact, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
