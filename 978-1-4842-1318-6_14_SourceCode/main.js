/* Initialize the Stripe and Mailgun Cloud Modules */
var Stripe = require('stripe');
Stripe.initialize('YOUR-STRIP-SECRET-KEY');

var Mailgun = require('mailgun');
Mailgun.initialize("YOUR-EMAIL-DOMAIN", "YOUR-MAILGUN-KEY");

Parse.Cloud.define("createStripeCustomer",function(request,response){
    Parse.Cloud.useMasterKey();
      
    Parse.Promise.as().then(function(){
        return Stripe.Customers.create({
        description: 'Customer for Beauty & Me',
        card:request.params.token,
        email:request.params.email
      
    }).then(null, function(error){
        console.log('Creating customer with stripe failed. Error: ' + error);
        return Parse.Promise.error('An error has occurred.');
    });
      
    }).then(function(customer) {
    response.success(customer.id);
  }, function(error) {
    response.error(error);
  });
});

Parse.Cloud.define("ChargeCustomer", function(request, response) {
  Parse.Cloud.useMasterKey();
  var order;
  var orderNo;
  var total;
  Parse.Promise.as().then(function() {
    var orderQuery = new Parse.Query('Order');
    orderQuery.equalTo('objectId', request.params.orderId);
    orderQuery.include("customer");
    orderQuery.include(["items.product"]);
    orderQuery.descending("createdAt");

    return orderQuery.first().then(null, function(error) {
      return Parse.Promise.error('Sorry, this order doesn\'t exist.');
    });

  }).then(function(result) {
    order = result;
    var items = order.get("items");
    for (var i=0; i<items.length;i++){
      var item = items[i];
      var unitPrice = item.get("product").get("unitPrice");
      var quantity = item.get("quantity");
      total += unitPrice *quantity;
    }
  }).then(function(result) {
    var countQuery = new Parse.Query("Order");
    return countQuery.count().then(null,function(error){
        return Parse.Promise.error('Something wrong.');
    });
  }).then(function(result) {
    orderNo = result;
  }).then(function(order){
 		return Stripe.Charges.create({
		  amount: total.toFixed(2)*100, // express dollars in cents 
		  currency: "usd",
		  customer:request.params.customerId
    }).then(null, function(error) {
      console.log('Charging with stripe failed. Error: ' + error);
      return Parse.Promise.error('An error has occurred. Your credit card was not charged.');
    });
  }).then(function(purchase) {
    orderNo = 1000000+orderNo+1;
    order.set('orderStatus', 1);  // order made
    order.set('orderNo', orderNo);
    order.set('stripePaymentId', purchase.id);
    return order.save().then(null, function(error) {
      return Parse.Promise.error('A critical error has occurred with your order. Please ' + 
                                 'contact us at your earliest convinience. ');
    });

  }).then(function(result) {
    var greeting = "Dear ";
    if (order.customer.firstName !== "N/A")
    	greeting +=  order.customer.firstName + ",\n\n";
    var orderId = "Order No. " + orderNo + "\n";	
    var body = greeting + orderId + "  We have received your order for the following item(s): \n\n" +
            request.params.itemDesc + "\n";

	body += "\Total: $" +  total.toFixed(2) + "\n\n";
   
    var thankyou = "Contact us if you have any question!\n\n" + 
    "\n Thank you,\n";
      
    body += thankyou;      
    	
    // Send the email.
    return Mailgun.sendEmail({
      to: order.customer.email,
      from: 'YOUR-CONTACT-EMAIL',
      subject: 'Your order was successful!',
      text: body
    }).then(null, function(error) {
      return Parse.Promise.error('Your purchase was successful, but we were not able to ' +
                                 'send you an email. Contact us if you have any questions.');
    });

  }).then(function() {
    // And we're done!
    response.success('Success');
  }, function(error) {
    response.error(error);
  });
});


Parse.Cloud.define("ChargeToken", function(request, response) {
  Parse.Cloud.useMasterKey();
  var order;
  var orderNo;
  var total;
  Parse.Promise.as().then(function() {
    var orderQuery = new Parse.Query('Order');
    orderQuery.equalTo('objectId', request.params.orderId);
    orderQuery.include("customer");
    orderQuery.include(["items.product"]);
    orderQuery.descending("createdAt");

    return orderQuery.first().then(null, function(error) {
      return Parse.Promise.error('Sorry, this order doesn\'t exist.');
    });

  }).then(function(result) {
    order = result;
    var items = order.get("items");
    for (var i=0; i<items.length;i++){
      var item = items[i];
      var unitPrice = item.get("product").get("unitPrice");
      var quantity = item.get("quantity");
      total += unitPrice *quantity;
    }
  }).then(function(result) {
    var countQuery = new Parse.Query("Order");
    return countQuery.count().then(null,function(error){
        return Parse.Promise.error('Something wrong.');
    });
  }).then(function(result) {
    orderNo = result;
  }).then(function(order){
 		return Stripe.Charges.create({
		  amount: total.toFixed(2)*100, // express dollars in cents 
		  currency: "usd",
		  chargeId:request.params.chargeToken
    }).then(null, function(error) {
      console.log('Charging with stripe failed. Error: ' + error);
      return Parse.Promise.error('An error has occurred. Your credit card was not charged.');
    });
  }).then(function(purchase) {
    orderNo = 1000000+orderNo+1;
    order.set('orderStatus', 1);  // order made
    order.set('orderNo', orderNo);
    order.set('stripePaymentId', purchase.id);
    return order.save().then(null, function(error) {
      return Parse.Promise.error('A critical error has occurred with your order. Please ' + 
                                 'contact us at your earliest convinience. ');
    });

  }).then(function(result) {
    var greeting = "Dear ";
    if (order.customer.firstName !== "N/A")
    	greeting +=  order.customer.firstName + ",\n\n";
    var orderId = "Order No. " + orderNo + "\n";	
    var body = greeting + orderId + "  We have received your order for the following item(s): \n\n" +
            request.params.itemDesc + "\n";

	body += "\Total: $" +  total.toFixed(2) + "\n\n";
   
    var thankyou = "Contact us if you have any question!\n\n" + 
    "\n Thank you,\n";
      
    body += thankyou;      
    	
    // Send the email.
    return Mailgun.sendEmail({
      to: order.customer.email,
      from: 'YOUR-CONTACT-EMAIL',
      subject: 'Your order was successful!',
      text: body
    }).then(null, function(error) {
      return Parse.Promise.error('Your purchase was successful, but we were not able to ' +
                                 'send you an email. Contact us if you have any questions.');
    });

  }).then(function() {
    // And we're done!
    response.success('Success');
  }, function(error) {
    response.error(error);
  });
});


