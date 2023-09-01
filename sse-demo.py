from flask import Flask, Response,  make_response
import time

app = Flask(__name__)


@app.route('/events')
def events():
    def generate_events():
        # 模拟事件生成
        for i in range(1, 11):
            yield 'data: Event {}\n\n'.format(i)
            time.sleep(1)

    return Response(generate_events(), mimetype='text/event-stream')


@app.route('/')
def index():
    html_content = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>SSE demo</title>
        <script>
            var eventSource = new EventSource('//127.0.0.1:5000/events');
    
            eventSource.onmessage = function(event) {
                var eventData = event.data;
                // 将数据展示在页面上
                var dataContainer = document.getElementById('data-container');
                dataContainer.innerHTML += '<p>' + eventData + '</p>';
            };
    
            eventSource.onerror = function(event) {
                // 处理错误
                console.error('SSE error:', event);
                eventSource.close();
            };
        </script>
    </head>
    <body>
        <h1>SSE 数据展示</h1>
        <div id="data-container"></div>
    </body>
    </html>
    """
    response = make_response(html_content)
    response.headers['Content-Type'] = 'text/html; charset=utf-8'
    return response


if __name__ == '__main__':
    app.run()
