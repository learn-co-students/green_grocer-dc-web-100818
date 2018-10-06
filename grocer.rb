require "pry"

def consolidate_cart(cart)
new = {}
cart.each do |item, data|
  item.each do |food, info|
    if new.has_key?(food) == false
      new[food] = info
    end
    if new[food].has_key?(:count)
       new[food][:count] += 1
    else
      new[food][:count] = 1
    end
  end
end
  new
end



def apply_coupons(cart, coupons)
  if coupons.size == 0
    return cart
  end
   new = {}
   cart.each do |item, data|
     coupons_applied = 0
     coupons.each do |coupon|
       if item == coupon[:item]
       coupon_num = coupon[:num]

       if coupon_num == cart[item][:count]
         coupons_applied += 1
         cart[item][:count] = 0
   elsif
     cart[item][:count] > coupons_applied
     coupons_applied += 1
       cart[item][:count] = (cart[item][:count] - coupon_num)
end
           new["#{item} W/COUPON"] = {
             price: coupon[:cost],
             clearance: cart[item][:clearance],
             count: coupons_applied
           }
end
end
end
cart.merge!(new)
end

def apply_clearance(cart)
  cart.each do |item, data|
    if data[:clearance] == true
      new_price = data[:price] * 0.8
     data[:price] = new_price.round(2)
    end
  end
  cart
end


def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)

  cart_total = 0
  cart.each do |item, data|
    cart_total += (data[:price] * data[:count])
  end

  if cart_total > 100
    cart_total = 0
    cart.each do |item, data|
      cart_total += ((data[:price] * 0.9).round(1) * data[:count])
    end
    return cart_total
  else
   return  cart_total
  end
end
