import { MessagingExtensionAttachment, MessagingExtensionResponse, TeamsActivityHandler } from 'botbuilder';
import { TurnContext, CardFactory, MessagingExtensionQuery, MessagingExtensionResult, Attachment } from 'botbuilder';

export class PlanetBot extends TeamsActivityHandler {
    public async onQuery(context: TurnContext, query: MessagingExtensionQuery): Promise<MessagingExtensionResponse> {
        // get the search query
        let searchQuery = '';
        if (query && query.parameters && query.parameters[0].name === 'searchKeyword' && query.parameters[0].value) {
            searchQuery = query.parameters[0].value.trim().toLowerCase();
        }

        // load planets
        const planets: any = require('./planets.json');
        // search results
        let queryResults: string[] = [];

        switch (searchQuery) {
            case 'inner':
                // get all planets inside asteroid belt
                queryResults = planets.filter((planet) => planet.id <= 4);
                break;
            case 'outer':
                // get all planets outside asteroid belt
                queryResults = planets.filter((planet) => planet.id > 4);
                break;
            default:
                // get the specified planet
                queryResults.push(planets.filter((planet) => planet.name.toLowerCase() === searchQuery)[0]);
        }

        // get the results as cards
        const searchResultsCards: MessagingExtensionAttachment[] = [];
        queryResults.forEach((planet) => {
            searchResultsCards.push(this.getPlanetResultCard(planet));
        });

        const response: MessagingExtensionResponse = {
            composeExtension: {
                type: 'result',
                attachmentLayout: 'list',
                attachments: searchResultsCards,
            },
        } as MessagingExtensionResponse;

        return Promise.resolve(response);
    }

    private getPlanetResultCard(selectedPlanet: any): MessagingExtensionAttachment {
        return CardFactory.heroCard(selectedPlanet.name, selectedPlanet.summary, [selectedPlanet.imageLink]);
    }
}
