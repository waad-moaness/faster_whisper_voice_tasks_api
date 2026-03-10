from utils.fuzzy_evaluation import check_fuzzy_keywords
from utils.shadowing_evaluation import sequance_matching_score
from utils.text_preprocessing import text_preprocessing

def evaluate(target_text: str, transcription_text: str, task_type: str):
    target_tokens = text_preprocessing(target_text)
    transcription_tokens = text_preprocessing(transcription_text)
    if task_type == "shadowing":

        score, report , correct_words_count = sequance_matching_score(target_tokens, transcription_tokens)
        score_status = score_status_encoded(score, len(target_tokens), correct_words_count)
        result = {"score_status": score_status
                  ,"word_status": report
                  }
        # for k, v in report.items():
        #       result[f"{k})"] = v

    elif task_type == "question":

        score_status = check_fuzzy_keywords(transcription_tokens, target_tokens)
        result = {
        "score_status": score_status
        }

    return result


def score_status_encoded(score, sent_length, correct_words_count=None):
    if score >= 90:
        return "excellent"

    elif sent_length <= 7:
        bad_words_count = sent_length - correct_words_count
        if correct_words_count > bad_words_count:
            return "good"
        else:
            return "poor"

    elif score >= 70:
        return "good"

    else:
        return "poor"