require "pry"

def consolidate_cart(cart)
  h = Hash.new(0)
  sorted = {}
  cart.each do |item|
    h[item] += 1
  end
  h.each do |hash, num|
    hash.each do |item, info|
      sorted[item] = info
      sorted[item][:count] = num
    end
  end
  return sorted
end


def apply_coupons(cart, coupons)
  new_cart = {}
  cart.each do |item, info|
    new_cart[item] = info
    coupons.each do |el|
      if item == el[:item] && info[:count] >= el[:num]
        new_cart[item] = new_cart[item] || {}
        new_cart[item][:count] = cart[item][:count] - el[:num]
        new_cart["#{item} W/COUPON"] = new_cart["#{item} W/COUPON"] || {}
        new_cart["#{item} W/COUPON"][:price] = el[:cost]
        new_cart["#{item} W/COUPON"][:clearance] = info[:clearance]
        if new_cart["#{item} W/COUPON"][:count] != nil
          new_cart["#{item} W/COUPON"][:count] += 1
        else 
          new_cart["#{item} W/COUPON"][:count] = 1
        end
      end
    end  
  end
  return new_cart
end


def apply_clearance(cart)
  new_cart = {}
  cart.each do |item, info|
    new_cart[item] = info
    if info[:clearance] == true
      new_cart[item]=new_cart[item] || info
      new_cart[item][:price] = info[:price] - info[:price]/100*20
    end
  end
  return new_cart
end


def checkout(cart, coupons)
  total = 0
  c = consolidate_cart(cart)
  c = apply_coupons(c, coupons)
  c = apply_clearance(c)

  c.each do |item, info|
    total += info[:price] * info[:count]
  end
  
  if total > 100
    total = total - total/100*10
  end
  return total
end
