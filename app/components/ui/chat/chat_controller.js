import { Controller } from "@hotwired/stimulus";
import { stimulus } from "~/init";

// Keeps the message list scrolled to the bottom as new messages arrive,
// but does not yank the viewport if the user has scrolled up to read history.
export default class ChatController extends Controller {
  static targets = ["messages"];
  static values = { threshold: { type: Number, default: 100 } };

  connect() {
    this.pinned = true;

    if (this.hasMessagesTarget) {
      this.messagesTarget.addEventListener("scroll", this.#handleScroll);
      this.observer = new window.MutationObserver(this.#handleMutation);
      this.observer.observe(this.messagesTarget, { childList: true });
    }

    this.scrollToBottom();
  }

  disconnect() {
    this.observer?.disconnect();
    if (this.hasMessagesTarget) {
      this.messagesTarget.removeEventListener("scroll", this.#handleScroll);
    }
  }

  scrollToBottom() {
    if (!this.hasMessagesTarget) return;
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
  }

  send(event) {
    if (event.key !== "Enter" || event.shiftKey) return;
    event.preventDefault();
    event.target.closest("form")?.requestSubmit();
  }

  #handleScroll = () => {
    this.pinned = this.#isNearBottom();
  };

  #handleMutation = (mutations) => {
    const added = mutations.some((mutation) => mutation.addedNodes.length > 0);
    if (added && this.pinned) {
      this.scrollToBottom();
    }
  };

  #isNearBottom() {
    const el = this.messagesTarget;
    return (
      el.scrollHeight - el.scrollTop - el.clientHeight <= this.thresholdValue
    );
  }
}

stimulus.register("chat", ChatController);
