*自分の環境を整備できるように

*使い方
**1.root下に、ruby1.8.7以上をインストールする
**2.chefというgemをインストールする
**3. .chef/solo.rbの修正
***file_cache_path: chef用tempfile_path
***cookbook_path: cookbookのpath
**4. .chef/chef.jsonの修正
***実行したいレシピをrun_listに入る
**5. vimrc/attributes/default.rbを修正して、user_idを追加してください
**6. cd path/to/cookbook && sudo chef-solo -c .chef/solo.rb -j .chef/chef.json　　　
