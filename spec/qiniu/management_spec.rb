# -*- encoding: utf-8 -*-

require 'digest/sha1'
require 'spec_helper'
require 'qiniu/auth'
require 'qiniu/management'
require 'qiniu'

module Qiniu
  module Storage
    describe Storage do

      before :all do
        @bucket = 'RubySDK-Test-Management'
        @bucket = make_unique_bucket(@bucket)

        ### 尝试创建Bucket
        result = Qiniu.mkbucket(@bucket)
        puts result.inspect

        @key = Digest::SHA1.hexdigest((Time.now.to_i+rand(100)).to_s)
        @key = make_unique_key_in_bucket(@key)

        @key2 = @key + rand(100).to_s
      end

      after :all do
        ### 不删除Bucket以备下次使用
      end

      ### 准备数据
      context ".upload_with_token_2" do
        it "should works" do
          upopts = {:scope => @bucket, :expires_in => 3600, :endUser => "why404@gmail.com"}
          uptoken = Qiniu.generate_upload_token(upopts)

          code, data, raw_headers = Qiniu::Storage.upload_with_token_2(
            uptoken,
            __FILE__,
            @key
          )
          code.should == 200
          puts data.inspect
        end
      end

      ### 列举Bucket
      context ".buckets" do
        it "should works" do
          code, data = Storage.buckets
          code.should == 200
          puts data.inspect
        end
      end

      context ".stat" do
        it "should works" do
          code, data = Storage.stat(@bucket, @key)
          code.should == 200
          puts data.inspect
        end
      end

      context ".get" do
        it "should works" do
          code, data = Storage.get(@bucket, @key)
          code.should == 200
          puts data.inspect
        end
      end

      context ".batch" do
        it "should works" do
          code, data = Storage.batch("stat", @bucket, [@key])
          code.should == 200
          puts data.inspect
        end
      end

      context ".batch_stat" do
        it "should works" do
          code, data = Storage.batch_stat(@bucket, [@key])
          code.should == 200
          puts data.inspect
        end
      end

      context ".batch_get" do
        it "should works" do
          code, data = Storage.batch_get(@bucket, [@key])
          code.should == 200
          puts data.inspect
        end
      end

      context ".batch_copy" do
        it "should works" do
          code, data = Storage.batch_copy @bucket, @key, @bucket, @key2
          code.should == 200
          puts data.inspect

          code, data = Storage.delete @bucket, @key2
          code.should == 200
          puts data.inspect
        end
      end

      context ".batch_move" do
        it "should works" do
          code, data = Storage.batch_move @bucket, @key, @bucket, @key2
          code.should == 200
          puts data.inspect

          code3, data3 = Storage.batch_move @bucket, @key2, @bucket, @key
          code3.should == 200
          puts data3.inspect
        end
      end

      context ".move" do
        it "should works" do
          code, data = Storage.move(@bucket, @key, @bucket, @key2)
          code.should == 200
          puts data.inspect

          code2, data2 = Storage.stat(@bucket, @key2)
          code2.should == 200
          puts data2.inspect

          code3, data3 = Storage.move(@bucket, @key2, @bucket, @key)
          code3.should == 200
          puts data3.inspect
        end
      end

      context ".copy" do
        it "should works" do
          code, data = Storage.copy(@bucket, @key, @bucket, @key2)
          code.should == 200
          puts data.inspect

          code, data = Storage.delete(@bucket, @key2)
          code.should == 200
          puts data.inspect
        end
      end

      context ".delete" do
        it "should works" do
          code, data = Storage.delete(@bucket, @key)
          code.should == 200
          puts data.inspect
        end
      end

    end
  end # module Storage
end # module Qiniu
