const appId = gon.application_id;
const locationId = gon.location_id;

async function initializeCard(payments) {
  const card = await payments.card();
  await card.attach('#card-container');
  return card;
}

async function createPayment(token) {
  const body = JSON.stringify({
    locationId,
    sourceId: token,
  });

  const paymentResponse = await fetch('/payment', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body,
  });

  if (paymentResponse.ok) {
    return paymentResponse.json();
  }

  const errorBody = await paymentResponse.text();
  throw new Error(errorBody);
}

async function tokenize(paymentMethod) {
  const tokenResult = await paymentMethod.tokenize();
  if (tokenResult.status === 'OK') {
    return tokenResult.token;
	
  } else {
    let errorMessage = `Tokenization failed with status: ${tokenResult.status}`;
    if (tokenResult.errors) {
      errorMessage += ` and errors: ${JSON.stringify(
        tokenResult.errors
      )}`;
    }
    //throw new Error(errorMessage);
	return errorMessage
  }
}

document.addEventListener('DOMContentLoaded', async function () {
  if (!window.Square) {
    return;
  }
  let payments;
  try {
    payments = window.Square.payments(appId, locationId);
  } catch(e) {
    const statusContainer = document.getElementById(
      'payment-status-container'
    );
    statusContainer.className = 'missing-credentials';
    statusContainer.style.visibility = 'visible';
  	console.error(e);
	
    return;
  }

  let card;
  try {
    card = await initializeCard(payments);
  } catch (e) {
    console.error('Initializing Card failed', e);
    return;
  }

  // Checkpoint 2.
  async function handlePaymentMethodSubmission(event, paymentMethod) {
    event.preventDefault();
    try {
        // disable the submit button as we await tokenization and make a payment request.
        cardButton.disabled = true;
        const token = await tokenize(paymentMethod);
		// nonceの値をhiddenの中に入れます
		document.getElementById('card-nonce').value = token;
    } catch (e) {
	  console.error(e.message);
      cardButton.disabled = false;
    }
  }

  const cardButton = document.getElementById('card-button');
  cardButton.addEventListener('click', async function (event) {
    await handlePaymentMethodSubmission(event, card);
	// 本来のフォームを送信します
	document.getElementById('payment-form').submit();
  });
});