class ContactsController < ApplicationController
  def index
    @contacts = Contact.all.order(created_at: :desc)
  end

  def bookings
    @bookings = Booking.order(date: :asc, time: :asc)
  end

  def delete_booking
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to bookings_list_path, notice: "Reservation deleted successfully."
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to contacts_path, notice: "Message deleted successfully."
  end
end
