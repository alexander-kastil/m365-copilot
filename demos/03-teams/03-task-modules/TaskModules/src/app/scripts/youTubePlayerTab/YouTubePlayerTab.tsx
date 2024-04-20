import * as React from 'react';
import { Provider, Flex, Text, Button, Header, ThemePrepared, Input } from '@fluentui/react-northstar';
import { teamsTheme, teamsDarkTheme, teamsHighContrastTheme } from '@fluentui/react-northstar';

import TeamsBaseComponent, { ITeamsBaseComponentState } from 'msteams-react-base-component';

import * as microsoftTeams from '@microsoft/teams-js';

export interface IYouTubePlayerTabState extends ITeamsBaseComponentState {
    entityId?: string;
    teamsTheme: ThemePrepared;
    youTubeVideoId?: string;
}

export interface IYouTubePlayerTabProps {}

export class YouTubePlayerTab extends TeamsBaseComponent<IYouTubePlayerTabProps, IYouTubePlayerTabState> {
    public async componentWillMount() {
        this.updateComponentTheme(this.getQueryVariable('theme'));

        this.setState(
            Object.assign({}, this.state, {
                youTubeVideoId: 'V1bFr2SWP1I',
            })
        );

        if (await this.inTeams()) {
            microsoftTeams.initialize();
            microsoftTeams.registerOnThemeChangeHandler(this.updateComponentTheme);
            microsoftTeams.getContext((context) => {
                microsoftTeams.appInitialization.notifySuccess();
                this.setState({
                    entityId: context.entityId,
                });
                this.updateTheme(context.theme);
            });
        } else {
            this.setState({
                entityId: 'This is not hosted in Microsoft Teams',
            });
        }
    }

    public render() {
        return (
            <Provider theme={this.state.teamsTheme}>
                <Flex column gap='gap.smaller'>
                    <Header>Task Module Demo</Header>
                    <Text>YouTube Video ID:</Text>
                    <Input value={this.state.youTubeVideoId} disabled></Input>
                    <Button content='Change Video ID' onClick={this.onChangeVideo}></Button>
                    <Button content='Show Video' primary onClick={this.onShowVideo}></Button>
                    <Text content='(C) Copyright Contoso' size='smallest'></Text>
                </Flex>
            </Provider>
        );
    }

    private appRoot(): string {
        if (typeof window === 'undefined') {
            return 'https://{{HOSTNAME}}';
        } else {
            return window.location.protocol + '//' + window.location.host;
        }
    }

    private onShowVideo = (event: React.MouseEvent<HTMLButtonElement>): void => {
        const taskInfoYoutube = {
            title: 'YouTube Player',
            url: this.appRoot() + `/youTubePlayerTab/player.html?vid=${this.state.youTubeVideoId}`,
            width: 1000,
            height: 700,
        };
        microsoftTeams.tasks.startTask(taskInfoYoutube);
    };

    private onChangeVideo = (event: React.MouseEvent<HTMLButtonElement>): void => {};

    private updateComponentTheme = (theme: string = 'default'): void => {
        let componentTheme: ThemePrepared;
        switch (theme) {
            case 'default':
                componentTheme = teamsTheme;
                break;
            case 'dark':
                componentTheme = teamsDarkTheme;
                break;
            case 'contrast':
                componentTheme = teamsHighContrastTheme;
                break;
            default:
                componentTheme = teamsTheme;
                break;
        }
        // update the state
        this.setState(
            Object.assign({}, this.state, {
                teamsTheme: componentTheme,
            })
        );
    };
}
