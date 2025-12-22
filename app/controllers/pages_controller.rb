class PagesController < ApplicationController
  def index
  end
  def about
  end
  def contact
    @contact = Contact.new
    @booking = Booking.new
  end

  def create_contact
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to "/contact", notice: "Thank you! Your message was sent and we´ll reply as soon as possible."
    else
      render :contact, status: :unprocessable_entity
    end
  end

  def create_booking
    @booking = Booking.new(booking_params)
    if @booking.save
      redirect_to contact_page_path, notice: "Reservation requested successfully. We will contact you to confim it."
    else
      @contact = Contact.new
      render :contact, status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:name, :email, :date, :time, :people)
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
