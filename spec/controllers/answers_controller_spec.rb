require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect do
          post :create, { question_id: question, answer: attributes_for(:answer), format: :js }
        end.to change(question.answers, :count).by(1)
      end

      it 'render new answer' do
        post :create, { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end

      it 'answer belongs to the user' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer).user_id).to eq @user.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        end.to_not change(Answer, :count)
      end

      it 'render new answer' do
        post :create, { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { sign_in answer.user }

      context 'User is author' do
        it 'delete answer' do
          expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
        end

        it 'redirect to question view' do
          delete :destroy, id: answer
          expect(response).to redirect_to question
        end
      end

      context 'User is not the author' do
        let(:another_user) { create(:user) }
        let!(:another_answer) { create(:answer, user: another_user, question: question) }
        render_views

        it 'try delete answer' do
          expect { delete :destroy, id: another_answer }.to_not change(Answer, :count)
        end

        it 're-renders question view' do
          delete :destroy, id: answer
          expect(response).to redirect_to question_path(question)
        end
      end
    end

    context 'Non-authenticated user' do
      it 'delete answer' do
        answer
        expect { delete :destroy, id: answer }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question) }
    it 'assigns the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the question' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes_for' do
      patch :update, id: answer, question_id: question, answer: { body: 'new body' } , format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end
  end
end
