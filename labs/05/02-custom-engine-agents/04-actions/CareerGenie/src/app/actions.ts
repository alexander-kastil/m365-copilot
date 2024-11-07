import { ApplicationTurnState } from './app';

function getCandidates(state: ApplicationTurnState, list: string): string[] {
    ensureListExists(state, list);
    return state.conversation.lists[list];
}

function setCandidates(state: ApplicationTurnState, list: string, Candidates: string[]): void {
    ensureListExists(state, list);
    state.conversation.lists[list] = Candidates ?? [];
}

function ensureListExists(state: ApplicationTurnState, listName: string): void {
    if (typeof state.conversation.lists != 'object') {
        state.conversation.lists = {};
    }

    if (!Object.prototype.hasOwnProperty.call(state.conversation.lists, listName)) {
        state.conversation.lists[listName] = [];
    }
}

function deleteList(state: ApplicationTurnState, listName: string): void {
    if (
        typeof state.conversation.lists == 'object' &&
        Object.prototype.hasOwnProperty.call(state.conversation.lists, listName)
    ) {
        delete state.conversation.lists[listName];
    }
}

export { getCandidates, setCandidates, ensureListExists, deleteList };