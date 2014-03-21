require 'spec_helper'
module Finitio
  describe MultiTupleType, "dress" do

    let(:heading){
      Heading.new([Attribute.new(:r, byte),
                   Attribute.new(:g, byte),
                   Attribute.new(:b, byte, false)])
    }

    let(:type){
      MultiTupleType.new(heading, "color")
    }

    subject{ type.dress(arg)  }

    context 'with a valid Hash' do
      let(:arg){
        { "r" => 12, "g" => 13, "b" => 255 }
      }
    
      it 'should coerce to a tuple' do
        subject.should eq(r: 12, g: 13, b: 255)
      end
    end

    context 'with a valid Hash and no optional' do
      let(:arg){
        { "r" => 12, "g" => 13 }
      }

      it 'should coerce to a tuple' do
        subject.should eq(r: 12, g: 13)
      end
    end

    context 'when raising an error' do
    
      subject do
        type.dress(arg) rescue $!
      end
    
      context 'with something else than a Hash' do
        let(:arg){
          "foo"
        }
    
        it 'should raise a TypeError' do
          subject.should be_a(TypeError)
          subject.message.should eq("Invalid value `foo` for color")
        end
    
        it 'should have no cause' do
          subject.cause.should be_nil
        end
    
        it 'should have an empty location' do
          subject.location.should eq('')
        end
      end
    
      context 'with a missing attribute' do
        let(:arg){
          { "r" => 12, "b" => 13 }
        }
    
        it 'should raise a TypeError' do
          subject.should be_a(TypeError)
          subject.message.should eq("Missing attribute `g`")
        end
    
        it 'should have no cause' do
          subject.cause.should be_nil
        end
    
        it 'should have an empty location' do
          subject.location.should eq('')
        end
      end
    
      context 'with an extra attribute' do
        let(:arg){
          { "r" => 12, "g" => 13, "extr" => 165 }
        }
    
        it 'should raise a TypeError' do
          subject.should be_a(TypeError)
          subject.message.should eq("Unrecognized attribute `extr`")
        end
    
        it 'should have no cause' do
          subject.cause.should be_nil
        end
    
        it 'should have an empty location' do
          subject.location.should eq('')
        end
      end
    
      context 'with an invalid attribute' do
        let(:arg){
          { "r" => 12, "g" => 13, "b" => 255.0 }
        }
    
        it 'should raise a TypeError' do
          subject.should be_a(TypeError)
          subject.message.should eq("Invalid value `255.0` for Byte")
        end
    
        it 'should have the correct cause' do
          subject.cause.should be_a(TypeError)
          subject.cause.message.should eq("Invalid value `255.0` for intType")
        end
    
        it 'should have the correct location' do
          subject.location.should eq("b")
        end
      end
    end

  end
end