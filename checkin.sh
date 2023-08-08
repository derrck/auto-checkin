if [ -f .env ]; then
  source .env
fi

#key="${PUSH_KEY}"

# 定义函数来提取JSON字段的值
get_json_value() {
    echo "$1" | grep -o "\"$2\":\"[^\"]*\"" | cut -d ":" -f 2 | sed 's/"//g'
}

echo '------------------sign------------------'
sign_result=$(curl -H "cookie:${COOKIE}" -H 'content-type:application/json;charset=UTF-8' -d '{"token": "glados.one"}' -X POST 'https://glados.rocks/api/user/checkin')
# sign_message=$(echo "$sign_result" | grep -Eo '"message":"[^"]*"')
sign_message=$(get_json_value "$sign_result" message) 

echo '-----------------status-----------------'
status_result=$(curl -H "cookie:${COOKIE}" -X GET 'https://glados.rocks/api/user/status')
# status_days=$(echo "$status_result" | grep -Eo '"leftDays":"[^"]*"')
status_days=$(get_json_value "$status_result" leftDays)
status_days=$(echo "$status_days" | bc -l | cut -d '.' -f 1)

text="GLaDOS: $sign_message 剩余 $status_days 天"
echo "GLaDOS: $sign_message 剩余 $status_days 天"
# text=${text//\"/}
# text="${text// /%20}"
# 将字符串进行URL编码
#text=$(printf "%s" "$text" | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g')

#url="https://api2.pushdeer.com/message/push?pushkey=${key}&text=${text}"
#curl -X GET "$url"
