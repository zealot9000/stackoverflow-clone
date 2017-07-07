require 'rails_helper'
require 'pry'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before do
      get :index
    end

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    # let(:question) { create(:question)}

    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user

    # let(:question) { create(:question)}

    before { get :edit, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new quiestion in the database' do
        # old_count = Question.count
        # post :create, question: attributes_for(:question) # { title: '123', body: 'abc'}
        # expect(Question.count).to eq old_count + 1
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirect to show' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))# (Question.last)
      end

      it 'question belongs to the user' do
        post :create, question: attributes_for(:question)
        expect(assigns(:question).user_id).to eq @user.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes_for' do
        patch :update, id: question, question: { title: 'MyString', body: 'MyText' }, format: :js
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 'render update template' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: nil }, format: :js }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 'render update template' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { sign_in question.user }

      context 'User is author' do
        it 'deletes question' do
          expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
        end

        it 'redirect to index view' do
          delete :destroy, id: question
          expect(response).to redirect_to questions_path
        end
      end

      context 'User is not author' do
        let(:another_user) { create(:user) }
        let(:another_question) { create(:question, user: another_user) }
        render_views

        it 'delete question' do
          another_question
          expect { delete :destroy, id: another_question }.to_not change(Question, :count)
        end

        it 're-renders question view' do
          delete :destroy, id: another_question
          expect(response).to render_template :show
          expect(response.body).to match another_question.title
        end
      end
    end
  end
end
