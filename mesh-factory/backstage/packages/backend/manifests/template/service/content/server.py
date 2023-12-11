from flask import Flask,jsonify,request

app = Flask(__name__)

@app.route('/data', methods = ['GET'])
def ReturnJSON():
	if(request.method == 'GET'):
		data = {
			"server" : "${{ values.name  }}",
			"msg" : "hi",
		}

		return jsonify(data)

if __name__=='__main__':
	 app.run(debug=True, port=8080)
