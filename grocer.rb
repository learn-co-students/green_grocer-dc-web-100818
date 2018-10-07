require "pry"

def consolidate_cart(cart)
  new_cart = {}
  uniq_cart = cart.uniq

  uniq_cart.each do |item|
    count = cart.count(item)

    item.each do |food, food_details|
      new_cart[food] = food_details
      new_cart[food][:count] = count
    end
  end

new_cart
end



def apply_coupons(cart, coupons)

  if coupons
    coupons.each do |coupon|
      #binding.pry
      food = coupon[:item]
      #binding.pry
      if cart.has_key?(food)
        coupon_label = "#{food} W/COUPON"
        if cart[food][:count] == coupon[:num]
          cart[coupon_label] = {}
          cart[coupon_label][:price] = coupon[:cost]
          cart[coupon_label][:clearance] = cart[food][:clearance]
          cart[coupon_label][:count] = 1
          cart[food][:count] = 0

        elsif cart[food][:count] > coupon[:num]
          cart[coupon_label] = {}
          cart[coupon_label][:clearance] = cart[food][:clearance]
          cart[coupon_label][:count] = cart[food][:count] / coupon[:num]
          cart[coupon_label][:price] = coupon[:cost]
          cart[food][:count] = (cart[food][:count] % coupon[:num])
        end
      end
    end
  end

  cart
end

def apply_clearance(cart)
  cart.each do |food, food_details|
    food_details.each do |label,value|
      #binding.pry
      if label == :clearance && value == true
        food_details[:price] = (food_details[:price] * 0.8).round(1)
      end
    end
  end

  cart
end

def checkout(cart, coupons)
  total = 0

  cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))

  cart.each do |food, food_details|
    #binding.pry
    total += food_details[:price] * food_details[:count]
  end

  if total > 100
    total *= 0.9
  end
  
  total
end
