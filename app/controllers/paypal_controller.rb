class PaypalController < ApplicationController

def checkout
    # 仮に、計 200 円の商品が買い物かごの中に入っていたとします。
    payment = PayPal::SDK::REST::Payment.new({
      intent: 'sale',
      payer: {
        payment_method: 'paypal',
      },
      redirect_urls: {
        return_url: 'http://localhost:3000/execute', # 買い手の承認が得られた場合の遷移先
        cancel_url: 'http://localhost:3000/', # 買い手がキャンセルしたときの遷移先
      },
      transactions: [
        {
          amount: {
            total: 200,
            currency: 'JPY',
          },
          item_list: {
            items: [
              {
                price: 100,
                currency: 'JPY',
                quantity: 1,
                name: 'サンプルアイテム A', # 日本語を使用する場合、本ファイルは UTF-8 で保存しましょう。
              },
              {
                price: 50,
                currency: 'JPY',
                quantity: 2,
                name: 'サンプルアイテム B', # 日本語を使用する場合、本ファイルは UTF-8 で保存しましょう。
              },
            ],
          },
        },
      ]})

    # PayPal API に HTTP POST リクエストを行い、その結果で処理を分岐します。
    if payment.create
      redirect_to payment.links.find{|v| v.rel == 'approval_url'}.href
    else
      render text: payment.error # 何らかのエラー処理を行います。
    end
  end

  def execute
    # 買い手の PayPal アカウントから売り手の PayPal アカウントへの支払いを実行します。
    payment = PayPal::SDK::REST::Payment.find(params[:paymentId])

    # 配送先の住所が必要な場合は以下のように格納されています。
    # 最終確認をしたい場合は execute の前に 1 ページ画面をはさみましょう。
    #payment.transactions.first.item_list.shipping_address 

    if payment.execute(payer_id: params[:PayerID]) # 本サンプルではそのまま決済を確定させます。
      render text: '決済が完了しました。'
    else
      render text: payment.error # 何らかのエラー処理を行います。
    end
  end


end
