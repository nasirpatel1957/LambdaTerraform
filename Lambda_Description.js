exports.handler = async (event) => {          //#(standard handling function for Lambda)
    console.log('Event: ', event);            //#(event is an object, which will print value posted by user)
    let responseMessage = 'Hello, World!';    //#(responseMessage is a variable)

    if (event.queryStringParameters && event.queryStringParameters['Name']) {   //#(it will fetch queryStringParameter data within object)
        responseMessage = 'Hello, ' + event.queryStringParameters['Name'] + '!';  //#(it will print my name)
    }

    if (event.httpMethod === 'POST') {                      //#(POST means to send data to backend); (GET means to request data from backend)
        const body = JSON.parse(event.body);                //#(JSON.parse will convert normal string to Javascript format like obj, arrays, function, etc) (const: let)
        responseMessage = 'Hello, ' + body.name + '!';      //#(will print name present in body.name)
    }

    const response = {                                     //#(Backend code: If status code is 200, it will send responseMessage) 
        statusCode: 200,
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            message: responseMessage
        }),
    };

    return response;                                //#(It will save & return my responseMessage & statusCode to the one who has called it)
};
