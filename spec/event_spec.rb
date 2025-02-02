require './lib/item'
require './lib/food_truck'
require './lib/event'

RSpec.describe Event do

  before(:each) do
    @event = Event.new("South Pearl Street Farmers Market")

    @food_truck1 = FoodTruck.new("Rocky Mountain Pies")
    @food_truck2 = FoodTruck.new("Ba-Nom-a-Nom")
    @food_truck3 = FoodTruck.new("Palisade Peach Shack")

    @item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
    @item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})

    @food_truck1.stock(@item1, 35)
    @food_truck1.stock(@item2, 7)
    @food_truck2.stock(@item4, 50)
    @food_truck2.stock(@item3, 25)
    @food_truck3.stock(@item1, 65)
  end

  it 'exists' do
    expect(@event).to be_an_instance_of(Event)
  end

  it 'has a name' do
    expect(@event.name).to eq("South Pearl Street Farmers Market")
  end

  it 'can hold food trucks' do
    expect(@event.food_trucks).to eq([])
  end

  it 'can add food trucks' do
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)

    expect(@event.food_trucks).to eq([@food_truck1, @food_truck2, @food_truck3])
  end

  it 'knows food truck names' do
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)
    expected = ["Rocky Mountain Pies", "Ba-Nom-a-Nom", "Palisade Peach Shack"]

    expect(@event.food_truck_names).to eq(expected)
  end

  it '#food_trucks_that_sell' do
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)

    expected1 = [@food_truck1, @food_truck3]
    expected2 = [@food_truck2]

    expect(@event.food_trucks_that_sell(@item1)).to eq(expected1)
    expect(@event.food_trucks_that_sell(@item4)).to eq(expected2)
  end

  it '#potential_revenue' do
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)

    expect(@food_truck1.potential_revenue).to eq(148.75)
    expect(@food_truck2.potential_revenue).to eq(345.00)
    expect(@food_truck3.potential_revenue).to eq(243.75)
  end

  it '#sorted_item_list' do
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)

    expected = ["Apple Pie (Slice)", "Banana Nice Cream", "Peach Pie (Slice)", "Peach-Raspberry Nice Cream"]

    expect(@event.sorted_item_list).to eq(expected)
  end

  xit '#total_inventory' do
    @food_truck3.stock(@item3, 10)

    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)

    expected = {
      @item1 => {
        quantity: 100,
        food_trucks: [@food_truck1, @food_truck3]
      },
      @item2 => {
        quantity: 7,
        food_trucks: [@food_truck1]
      },
      @item3 => {
        quantity: 50,
        food_trucks: [@food_truck2, @food_truck3]
      },
      @item4 => {
        quantity: 35,
        food_trucks: [@food_truck2]
      }
    }

    expect(@event.total_inventory).to eq(expected)
  end

  xit 'overstocked items' do
    @food_truck3.stock(@item3, 10)

    expect(@event.overstocked_items).to eq([])
  end

end
