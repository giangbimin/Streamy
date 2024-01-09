user = User.create(email: "example@example.com", name: "example")
hall_id = Hall.create( name: "landmark Hall", seat_amount: 1050).id
hall_seats = (1..1050).to_a.map do |i| {seat_number: i, hall_id: hall_id} end
HallSeat.insert_all(hall_seats)
event = Event.create(
  name: "Test Event",
  description: "Event description",
  start_time: Time.now + 2.days,
  end_time: Time.now + 2.days + 4.hours,
  hall_id: hall_id
)
seat_categories = [
  { event_id: event.id, name: "general", base_price: 100, quantity: 600, unoccupied_count: 0 },
  { event_id: event.id, name: "vip", base_price: 300, quantity: 250, unoccupied_count: 0 },
  { event_id: event.id, name: "box", base_price: 500, quantity: 150, unoccupied_count: 0 },
  { event_id: event.id, name: "front_pro", base_price: 1000, quantity: 50, unoccupied_count: 0 }
]
SeatCategory.insert_all(seat_categories)
seat_ids = HallSeat.ids
event_seats = []
SeatCategory.all.each do |catetory|
  cur_seat_index = 0
  catetory.quantity.times do
    event_seats << {seat_category_id: catetory.id, hall_seat_id: seat_ids[cur_seat_index]}
    cur_seat_index += 1
  end
end
EventSeat.insert_all(event_seats)
cart = Cart.create(user_id: user.id, status: :active)
CartItem.create(cart_id: cart.id, event_seat_id: EventSeat.first.id, price_estimate_rule: 0, price: 1000.5)
CartItem.create(cart_id: cart.id, event_seat_id: EventSeat.second.id, price_estimate_rule: 0, price: 1000.5)
CartItem.create(cart_id: cart.id, event_seat_id: EventSeat.last.id, price_estimate_rule: 0, price: 1000.5)
order = Order.create(cart_id: cart.id, total_price: 1000)
Ticket.create(order_id: order.id, event_seat_id: CartItem.first.event_seat_id)
Payment.create(order_id: order.id, user_id: user.id, transaction_status: 1)