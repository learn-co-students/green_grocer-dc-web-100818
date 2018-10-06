def consolidate_cart(cart)
  final_hash = {}
  count = Hash.new(0)
  cart.each do |hash|
    count[hash] += 1 
  end 
  
  count.collect do |hash, value|
    hash.collect do |item, info_hash|
      final_hash[item] = info_hash
      final_hash[item][:count] = value
    end 
  end 
  final_hash 
end

def apply_coupons(cart, coupons)
    coupons.each do |hash|
      if (cart.keys.include? (hash[:item]))
        if cart[hash[:item]][:count] >= hash[:num]
          cart[hash[:item]][:count] -= hash[:num]
          if cart.keys.include? ("#{hash[:item]} W/COUPON")
            cart["#{hash[:item]} W/COUPON"][:count] += 1 
          else 
            new_hash = {}
            new_hash["#{hash[:item]} W/COUPON"] = {:price => hash[:cost], :clearance => cart[hash[:item]][:clearance], :count => 1}
            cart = cart.merge(new_hash)
          end 
        end 
      end 
    end 
    cart
end

def apply_clearance(cart)
  cart.collect do |item_name, info_hash|
    if cart[item_name][:clearance] == true 
      cart[item_name][:price] = (cart[item_name][:price] * 0.80).round(2)
    end
  end 
  cart 
end

def checkout(cart, coupons)
  total = 0 
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  
  cart.each do |item, hash|
    total += cart[item][:price] * cart[item][:count]
  end 
  
  if total > 100
    total = total * 0.90
  end
  total 
end
