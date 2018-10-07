require "pry"

def consolidate_cart(cart)
  proper_cart = {}
  cart.each do |item_hash| 
    item_hash.each do |name, info| 
      if !proper_cart[name]
        proper_cart[name] = {}
      end
      if !proper_cart[name][info] 
        proper_cart[name] = info
      end
      if !proper_cart[name][:count]
        proper_cart[name][:count] = 1
      else
        proper_cart[name][:count] += 1
      end
    end   
  end
  proper_cart
end

def apply_coupons(cart, coupons) 
  coupons.each do |coupon|
    item = coupon[:item]
      if cart.has_key?(item)
        num_items = cart[item][:count]
        num_with_c = num_items / coupon[:num]
        num_after = num_items % coupon[:num]
          if num_with_c > 0
            cart[item][:count] = num_after
            cart["#{item} W/COUPON"] = {
            :price => coupon[:cost],
            :clearance => cart[item][:clearance],
            :count => num_with_c }
          end
        end
      end
    cart
end

def apply_clearance(cart)
  cart.each do |item, item_info|
    if item_info[:clearance] == true
      item_info[:price] = (item_info[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  total_cost = 0
  updated_cart = consolidate_cart(cart)
  cart_w_coupons = apply_coupons(updated_cart, coupons)
  final_cart = apply_clearance(cart_w_coupons)
    
  final_cart.each do |name,info|
    total_cost += info[:price] * info[:count]
   end 
    
    if total_cost > 100
      total_cost *= 0.9
      
  end
  total_cost
end
